#!/bin/bash

# ==============================================================================
# Master Project Generation Script for the "Disease Hotspot Analyst" QGIS Plugin
# ==============================================================================
# This script creates the complete, portable directory structure and all necessary
# files with their full content, ready to be pushed to a GitHub repository.
# It is designed to be run in a command-line environment like GitHub Codespace.
# ==============================================================================

# Exit immediately if a command exits with a non-zero status.
set -e

PLUGIN_DIR="qgis-disease-hotspot-analyst"
echo "--- Creating the QGIS Plugin repository structure in './$PLUGIN_DIR' ---"

# Create the main plugin directory and subdirectories
mkdir -p "$PLUGIN_DIR/icons"
mkdir -p "$PLUGIN_DIR/.github/ISSUE_TEMPLATE"
cd "$PLUGIN_DIR"

# ==============================================================================
# CREATE GITHUB-SPECIFIC FILES (README, LICENSE, ISSUE TEMPLATES)
# ==============================================================================

echo "Creating README.md (the project home page)..."
cat << 'EOF' > README.md
# QGIS Plugin: Disease Hotspot Analyst

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![QGIS Version](https://img.shields.io/badge/QGIS-3.10+-green.svg)](https://www.qgis.org/)
[![Status](https://img.shields.io/badge/status-active-success.svg)]()

A professional QGIS plugin for animal health surveillance that connects to a live database to find and visualize statistically significant disease outbreak clusters. This tool transforms raw outbreak data into an actionable map of hotspots, cold spots, and spatial outliers, enabling data-driven decisions for targeted intervention and surveillance.

---
### Screenshot
*A visual example showing the dockable widget on the right and the styled LISA cluster map output on the QGIS canvas.*

*(Add a screenshot of the plugin in action here)*

---
## Key Features

-   **🌐 Direct Database Connection:** Securely connects to your Supabase (PostgreSQL) database to ensure every analysis uses the most current, authoritative data.
-   **🔎 Intuitive Filtering:** Allows users to perform targeted analysis by filtering outbreak data directly in the plugin's interface based on **Disease Type** and a specific **Date Range**.
-   **🧠 Automated Statistical Analysis:** In the background, the plugin automatically aggregates outbreak points into administrative boundaries and runs a **Local Moran's I (LISA)** statistical test to identify significant clusters.
-   **🗺️ Clear, Actionable Visualization:** Automatically adds a new, styled vector layer to the QGIS map canvas, with an intuitive color scheme to instantly identify:
    -   🔴 **High-High (Hotspots):** Areas with high outbreak counts, surrounded by other high-count areas.
    -   🔵 **Low-Low (Cold Spots):** Areas with low outbreak counts, surrounded by other low-count areas.
    -   🟠 **Spatial Outliers:** Indicating potential new incursions or areas of effective control.

## Installation

### Prerequisites
1.  **QGIS 3.10 or higher** installed.
2.  The required **Python libraries** must be installed *in the QGIS Python environment*. The easiest way to do this is to open the **OSGeo4W Shell** (on Windows) or your terminal (Linux/macOS) that is configured for your QGIS installation and run:
    \`\`\`bash
    pip install supabase geopandas esda libpysal splot
    \`\`\`

### Installation Steps
1.  **Download the Plugin:** Go to the [Releases page](https://github.com/bayillag/qgis-disease-hotspot-analyst/releases) of this repository and download the latest \`.zip\` file.
2.  **Install from ZIP:** In QGIS, go to **Plugins -> Manage and Install Plugins... -> Install from ZIP**.
3.  **Select the downloaded ZIP file** and click **"Install Plugin"**.
4.  **Enable the Plugin:** After installation, find "Disease Hotspot Analyst" in the "Installed" tab and make sure the checkbox next to it is checked.

## Configuration

**⚠️ IMPORTANT:** Before the plugin can connect to your database, you must provide your credentials. Open the file \`disease_hotspot_analyst_dockwidget.py\` in a text editor and replace the placeholder values with your actual Supabase URL and Key.

## How to Use
1.  Click the **Disease Hotspot Analyst** icon in the toolbar or go to the **Plugins -> Disease Hotspot Analyst** menu to open the dockable widget.
2.  The plugin will automatically fetch the list of available diseases from your database.
3.  Select a **Disease**, a **Start Date**, and an **End Date**.
4.  Click the **"Run Hotspot Analysis"** button.
5.  The plugin will perform the analysis and, if significant clusters are found, a new styled layer will be added to your map canvas.

## Bug Reports & Feature Requests
Found a bug or have an idea for a new feature? Please [open an issue](https://github.com/your-username/qgis-disease-hotspot-analyst/issues/new/choose) and select the appropriate template.

## Contributing
Contributions are welcome! If you would like to contribute code, please fork the repository and open a pull request.

## License
This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
EOF

echo "Creating LICENSE file..."
cat << 'EOF' > LICENSE
MIT License

Copyright (c) 2025 Dr Bayilla Geda

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

echo "Creating .gitignore..."
cat << 'EOF' > .gitignore
# Python
__pycache__/
*.pyc
venv/
.env*
resources.py

# QGIS
*.qgz
*.qgs
EOF

echo "Creating GitHub Issue Templates..."
cat << 'EOF' > .github/ISSUE_TEMPLATE/bug_report.md
---
name: 🐛 Bug Report
about: Create a report to help us improve the plugin
title: "[BUG] A brief, descriptive title of the bug"
labels: bug, needs-triage
assignees: ''
---
**Describe the bug**
A clear and concise description of what the bug is.
**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. See error '...'
**Expected behavior**
A clear and concise description of what you expected to happen.
**Screenshots**
If applicable, add screenshots to help explain your problem, especially from the QGIS Log Messages Panel.
**Desktop Environment:**
 - OS: [e.g. Windows 10]
 - QGIS Version: [e.g. 3.28.3]
EOF

cat << 'EOF' > .github/ISSUE_TEMPLATE/feature_request.md
---
name: ✨ Feature Request
about: Suggest an idea or new functionality for this plugin
title: "[FEAT] A brief title for your feature idea"
labels: enhancement, needs-triage
assignees: ''
---
**Is your feature request related to a problem? Please describe.**
A clear and concise description of what the problem is. Ex. "I'm always frustrated when [...]"
**Describe the solution you'd like**
A clear and concise description of what you want to happen.
EOF

# ==============================================================================
# CREATE PLUGIN METADATA, RESOURCES, AND UI
# ==============================================================================

echo "Creating metadata.txt..."
cat << 'EOF' > metadata.txt
[general]
name=Disease Hotspot Analyst
qgisMinimumVersion=3.10
description=A plugin to analyze animal disease outbreaks and identify statistically significant spatial clusters (hotspots).
version=1.0
author=Dr Bayilla Geda
email=bayillag@gmail.com
[plugin-dependencies]
EOF

echo "Creating icons/icon.svg..."
cat << 'EOF' > icons/icon.svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><path d="M50 5 C25 5 25 30 25 30 C25 60 50 95 50 95 C50 95 75 60 75 30 C75 30 75 5 50 5 Z" fill="#e74c3c" stroke="#c0392b" stroke-width="2"/><rect x="45" y="25" width="10" height="30" fill="white"/><rect x="30" y="40" width="40" height="10" fill="white"/></svg>
EOF

echo "Creating resources.qrc..."
cat << 'EOF' > resources.qrc
<RCC><qresource prefix="/plugins/disease_hotspot_analyst"><file>icons/icon.svg</file></qresource></RCC>
EOF

echo "Creating disease_hotspot_analyst_dockwidget_base.ui..."
cat << 'EOF' > disease_hotspot_analyst_dockwidget_base.ui
<?xml version="1.0" encoding="UTF-8"?><ui version="4.0"><class>DiseaseHotspotAnalystDockWidgetBase</class><widget class="QDockWidget" name="DiseaseHotspotAnalystDockWidgetBase"><property name="geometry"><rect><x>0</x><y>0</y><width>320</width><height>400</height></rect></property><property name="windowTitle"><string>Disease Hotspot Analyst</string></property><widget class="QWidget" name="dockWidgetContents"><layout class="QVBoxLayout" name="verticalLayout"><item><widget class="QLabel" name="label"><property name="font"><font><pointsize>10</pointsize><weight>75</weight><bold>true</bold></font></property><property name="text"><string>Filter Outbreaks</string></property></widget></item><item><widget class="QLabel" name="label_2"><property name="text"><string>Disease:</string></property></widget></item><item><widget class="QComboBox" name="diseaseComboBox"/></item><item><widget class="QLabel" name="label_3"><property name="text"><string>Start Date:</string></property></widget></item><item><widget class="QDateEdit" name="startDateEdit"><property name="calendarPopup"><bool>true</bool></property></widget></item><item><widget class="QLabel" name="label_4"><property name="text"><string>End Date:</string></property></widget></item><item><widget class="QDateEdit" name="endDateEdit"><property name="calendarPopup"><bool>true</bool></property></widget></item><item><spacer name="verticalSpacer"><property name="orientation"><enum>Qt::Vertical</enum></property><property name="sizeHint" stdset="0"><size><width>20</width><height>40</height></size></property></spacer></item><item><widget class="QPushButton" name="runAnalysisButton"><property name="styleSheet"><string notr="true">background-color: #27ae60; color: white; padding: 5px; border-radius: 3px;</string></property><property name="text"><string>Run Hotspot Analysis</string></property></widget></item><item><widget class="QLabel" name="statusLabel"><property name="styleSheet"><string notr="true">color: grey;</string></property><property name="text"><string>Status: Ready</string></property></widget></item></layout></widget></widget><resources/><connections/></ui>
EOF

# ==============================================================================
# CREATE THE CORE PYTHON FILES
# ==============================================================================

echo "Creating __init__.py..."
cat << 'EOF' > __init__.py
def classFactory(iface):
    from .disease_hotspot_analyst import DiseaseHotspotAnalyst
    return DiseaseHotspotAnalyst(iface)
EOF

echo "Creating disease_hotspot_analyst.py (main plugin file)..."
cat << 'EOF' > disease_hotspot_analyst.py
import os.path
from qgis.PyQt.QtWidgets import QAction
from qgis.PyQt.QtGui import QIcon
from .resources import *
from .disease_hotspot_analyst_dockwidget import DiseaseHotspotAnalystDockWidget

class DiseaseHotspotAnalyst:
    def __init__(self, iface):
        self.iface = iface
        self.plugin_dir = os.path.dirname(__file__)
        self.actions = []
        self.menu = u'&Disease Hotspot Analyst'
        self.toolbar = self.iface.addToolBar(u'DiseaseHotspotAnalyst')
        self.toolbar.setObjectName(u'DiseaseHotspotAnalyst')
        self.dockwidget = None

    def add_action(self, icon_path, text, callback, parent=None):
        icon = QIcon(icon_path)
        action = QAction(icon, text, parent)
        action.triggered.connect(callback)
        self.toolbar.addAction(action)
        self.iface.addPluginToMenu(self.menu, action)
        self.actions.append(action)
        return action

    def initGui(self):
        icon_path = ':/plugins/disease_hotspot_analyst/icons/icon.svg'
        self.add_action(icon_path, text=u'Run Disease Hotspot Analysis', callback=self.run, parent=self.iface.mainWindow())
        self.first_run = True

    def unload(self):
        if self.dockwidget: self.iface.removeDockWidget(self.dockwidget)
        for action in self.actions:
            self.iface.removePluginMenu(u'&Disease Hotspot Analyst', action)
            self.iface.removeToolBarIcon(action)
        del self.toolbar

    def run(self):
        if self.first_run:
            self.first_run = False
            self.dockwidget = DiseaseHotspotAnalystDockWidget()
        self.iface.addDockWidget(2, self.dockwidget) # 2 is Qt.RightDockWidgetArea
        self.dockwidget.show()
EOF

echo "Creating disease_hotspot_analyst_dockwidget.py (UI logic)..."
cat << 'EOF' > disease_hotspot_analyst_dockwidget.py
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
EOF

# ==============================================================================
# FINAL MESSAGE
# ==============================================================================
cd ..
echo ""
echo "✅ GitHub repository for 'qgis-disease-hotspot-analyst' created successfully."
echo ""
echo "--- Next Steps ---"
echo "1. IMPORTANT: Edit the file '$PLUGIN_DIR/disease_hotspot_analyst_dockwidget.py' and replace YOUR_SUPABASE_URL and YOUR_SUPABASE_ANON_KEY with your actual credentials."
echo "2. Compile the resources: cd $PLUGIN_DIR && pyrcc5 -o resources.py resources.qrc && cd .."
echo "3. ZIP the '$PLUGIN_DIR' folder to prepare it for installation in QGIS."
echo "4. In QGIS, go to Plugins -> Manage and Install Plugins -> Install from ZIP."
echo "------------------"