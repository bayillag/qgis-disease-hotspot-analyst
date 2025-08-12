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
