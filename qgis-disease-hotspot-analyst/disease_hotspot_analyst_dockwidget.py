import os
from datetime import date
import warnings
from qgis.PyQt import uic
from qgis.PyQt.QtWidgets import QDockWidget
from qgis.PyQt.QtCore import QDate
from qgis.core import ( QgsVectorLayer, QgsProject, QgsCategorizedSymbolRenderer, QgsSymbol, QgsRendererCategory, QgsMessageLog, Qgis )
from qgis.utils import iface
import pandas as pd
import geopandas as gpd
from supabase import create_client, Client
from esda.moran import Moran_Local
from libpysal.weights import Queen

FORM_CLASS, _ = uic.loadUiType(os.path.join(os.path.dirname(__file__), 'disease_hotspot_analyst_dockwidget_base.ui'))

class DiseaseHotspotAnalystDockWidget(QDockWidget, FORM_CLASS):
    def __init__(self, parent=None):
        super(DiseaseHotspotAnalystDockWidget, self).__init__(parent)
        self.setupUi(self)
        url = os.environ.get("SUPABASE_URL", "YOUR_SUPABASE_URL")
        key = os.environ.get("SUPABASE_ANON_KEY", "YOUR_SUPABASE_ANON_KEY")
        self.supabase: Client = create_client(url, key)
        self.runAnalysisButton.clicked.connect(self.run_analysis)
        self.startDateEdit.setDate(QDate.currentDate().addYears(-1))
        self.endDateEdit.setDate(QDate.currentDate())
        self.populate_disease_filter()

    def populate_disease_filter(self):
        self.statusLabel.setText("Status: Fetching diseases..."); iface.mainWindow().repaint()
        try:
            res = self.supabase.table("animal_diseases").select("disease_name").execute()
            diseases = ['All Diseases'] + sorted([d['disease_name'] for d in res.data])
            self.diseaseComboBox.addItems(diseases)
            self.statusLabel.setText("Status: Ready")
        except Exception as e:
            self.statusLabel.setText("Error: DB connection failed.")
            iface.messageBar().pushMessage("Error", f"Could not connect: {e}", level=Qgis.Critical, duration=10)

    def style_lisa_layer(self, layer):
        categories = { 1: ('High-High (Hotspot)', '#d7191c'), 2: ('Low-High (Outlier)', '#fdae61'), 3: ('Low-Low (Cold Spot)', '#2c7bb6'), 4: ('High-Low (Outlier)', '#abd9e9') }
        qgis_categories = []
        for code, (label, color) in categories.items():
            symbol = QgsSymbol.defaultSymbol(layer.geometryType()); symbol.setColor(color); symbol.setOpacity(0.7)
            qgis_categories.append(QgsRendererCategory(code, symbol, label))
        renderer = QgsCategorizedSymbolRenderer('lisa_q', qgis_categories); layer.setRenderer(renderer); layer.triggerRepaint()

    def run_analysis(self):
        self.statusLabel.setText("Status: Starting analysis..."); iface.mainWindow().repaint()
        try:
            selected_disease, start_date, end_date = self.diseaseComboBox.currentText(), self.startDateEdit.date().toString("yyyy-MM-dd"), self.endDateEdit.date().toString("yyyy-MM-dd")
            self.statusLabel.setText("Status: Fetching data..."); iface.mainWindow().repaint()
            query = self.supabase.table("animal_disease_events_logbook").select("disease_name, reported_date, latitude, longitude").gte("reported_date", start_date).lte("reported_date", end_date)
            if selected_disease != 'All Diseases': query = query.eq("disease_name", selected_disease)
            df_outbreaks = pd.DataFrame(query.execute().data)
            df_woredas = pd.DataFrame(self.supabase.table("admin_woredas").select("woreda_name, woreda_pcode, woreda_map").execute().data)
            if df_outbreaks.empty:
                iface.messageBar().pushMessage("Info", "No outbreaks found.", level=Qgis.Info); self.statusLabel.setText("Status: No outbreaks found."); return
            self.statusLabel.setText("Status: Preparing data..."); iface.mainWindow().repaint()
            outbreaks_gdf = gpd.GeoDataFrame(df_outbreaks, geometry=gpd.points_from_xy(pd.to_numeric(df_outbreaks.longitude), pd.to_numeric(df_outbreaks.latitude)), crs="EPSG:4269")
            gdf_woredas = gpd.GeoDataFrame(df_woredas, geometry=gpd.GeoSeries.from_wkb([bytes.fromhex(g[4:]) for g in df_woredas['woreda_map']]), crs="EPSG:4269")
            self.statusLabel.setText("Status: Aggregating data..."); iface.mainWindow().repaint()
            with warnings.catch_warnings():
                warnings.simplefilter("ignore"); joined_gdf = gpd.sjoin(outbreaks_gdf, gdf_woredas, how="inner", predicate='within')
            counts = joined_gdf['woreda_pcode'].value_counts().reset_index(); counts.columns = ['woreda_pcode', 'count']
            gdf_counts = gdf_woredas.merge(counts, on='woreda_pcode', how='left').fillna(0)
            self.statusLabel.setText("Status: Calculating hotspots..."); iface.mainWindow().repaint()
            w = Queen.from_dataframe(gdf_counts); w.transform = 'r'
            moran_local = Moran_Local(gdf_counts['count'], w)
            gdf_counts['lisa_q'] = moran_local.q; gdf_counts['lisa_p'] = moran_local.p_sim
            significant = gdf_counts[(gdf_counts['lisa_p'] < 0.05) & (gdf_counts['count'] > 0)]
            if significant.empty:
                iface.messageBar().pushMessage("Info", "No significant clusters found.", level=Qgis.Info); self.statusLabel.setText("Status: No clusters."); return
            self.statusLabel.setText("Status: Adding layer..."); iface.mainWindow().repaint()
            layer_name = f"Hotspots_{selected_disease.replace(' ', '_')}_{date.today()}"; vl = QgsVectorLayer.fromGpd(significant, layer_name)
            QgsProject.instance().addMapLayer(vl); self.style_lisa_layer(vl)
            self.statusLabel.setText("Status: Analysis complete!")
            iface.messageBar().pushMessage("Success", f"Layer '{layer_name}' added.", level=Qgis.Success)
        except Exception as e:
            self.statusLabel.setText("Error: An error occurred."); QgsMessageLog.logMessage(f"Hotspot Error: {e}", 'DiseaseHotspotAnalyst', level=Qgis.Critical)
            iface.messageBar().pushMessage("Error", "Analysis failed. See log for details.", level=Qgis.Critical)
