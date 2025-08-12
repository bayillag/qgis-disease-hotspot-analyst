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
