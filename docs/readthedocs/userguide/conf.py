# Sphinx configuration for the WRF-Hydro / CTSM user guide.
# Build locally with `make` in doc/readthedocs; Read the Docs uses the same file.
# Full reference: https://www.sphinx-doc.org/en/master/usage/configuration.html

project = "WRF-Hydro CTSM Coupling"
author = "NCAR"
copyright = "2026, NCAR"
release = "0.1"

extensions = [
    'sphinx_rtd_theme',
    'sphinx_copybutton',
]

copybutton_prompt_text = r"\$ "
copybutton_prompt_is_regexp = True

templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]

html_theme = "sphinx_rtd_theme"
html_static_path = ["_static"]
