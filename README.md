# QGIS Plugin: Disease Hotspot Analyst

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![QGIS Version](https://img.shields.io/badge/QGIS-3.10+-green.svg)](https://www.qgis.org/)
[![Python Version](https://img.shields.io/badge/python-3.7+-blue.svg)](https://www.python.org/)

A professional QGIS plugin for animal health surveillance that connects to a live database to find and visualize statistically significant disease outbreak clusters. This tool transforms raw outbreak data into an actionable map of hotspots, cold spots, and spatial outliers, enabling data-driven decisions for targeted intervention and surveillance.

---

### Screenshot
*(This is where you would place a screenshot of the plugin in action within QGIS)*
 
*A visual example showing the dockable widget and the styled LISA cluster map output.*

---

## Key Features

*   **Direct Database Connection:** Securely connects to your Supabase (PostgreSQL) database to ensure every analysis uses the most current, authoritative data.
*   **Intuitive Filtering:** Allows users to perform targeted analysis by filtering outbreak data directly in the plugin's interface based on **Disease Type** and a specific **Date Range**.
*   **Automated Statistical Analysis:** In the background, the plugin automatically aggregates outbreak points into administrative boundaries and runs a **Local Moran's I (LISA)** statistical test to identify significant clusters.
*   **Clear, Actionable Visualization:** Automatically adds a new, styled vector layer to the QGIS map canvas, with an intuitive color scheme to instantly identify:
    *   🔴 **High-High (Hotspots):** Areas with high outbreak counts, surrounded by other high-count areas.
    *   🔵 **Low-Low (Cold Spots):** Areas with low outbreak counts, surrounded by other low-count areas.
    *   🟠 **Spatial Outliers:** High-risk areas next to low-risk neighbors (and vice versa), indicating potential new incursions or areas of effective control.

## Installation

### Prerequisites
1.  **QGIS 3.10 or higher** installed.
2.  The required **Python libraries** must be installed *in the QGIS Python environment*. The easiest way to do this is to open the **OSGeo4W Shell** (on Windows) or your terminal (Linux/macOS) that is configured for your QGIS installation and run:
    ```bash
    pip install supabase "geopandas<1.0" esda libpysal splot
    ```

### Installation Steps
1.  **Clone or Download this Repository:**
    ```bash
    git clone https://github.com/your-username/qgis-disease-hotspot-analyst.git
    ```
2.  **Compile the Resources:** The plugin uses an icon that needs to be compiled into a Python file. Navigate into the cloned directory and run the compile script:
    ```bash
    cd qgis-disease-hotspot-analyst
    ./compile-resources.sh
    ```
3.  **Find your QGIS Plugins Directory:**
    *   In QGIS, go to **Settings -> User Profiles -> Open Active Profile Folder**.
    *   Inside this folder, navigate to `python/plugins`.
4.  **Copy the Plugin Folder:** Copy the entire `qgis-disease-hotspot-analyst` folder into the `plugins` directory you just opened.
5.  **Restart QGIS.**
6.  **Enable the Plugin:**
    *   Go to **Plugins -> Manage and Install Plugins...**.
    *   In the "Installed" tab, find "Disease Hotspot Analyst" and check the box to enable it.
    *   A new icon will appear on a toolbar, and a new menu item will be available under **Plugins -> Disease Hotspot Analyst**.

## Configuration

**⚠️ IMPORTANT:** Before the plugin can connect to your database, you must add your credentials.

Open the file `qgis-disease-hotspot-analyst/disease_hotspot_analyst_dockwidget.py` in a text editor and replace the placeholder values with your actual Supabase URL and Key:

```python
# Find this section in the file:
url = os.environ.get("SUPABASE_URL", "YOUR_SUPABASE_URL")
key = os.environ.get("SUPABASE_ANON_KEY", "YOUR_SUPABASE_ANON_KEY")
