AUTHOR = "Katherine E. Stange"
SITENAME = "Math 8114 – Mathematical Computation"
SITESUBTITLE = "Fall 2025 · MWF 10:10–11:00 · Duane G2B60"
SITEURL = ""  # keep empty for dev; set in publishconf.py

PATH = "content"
TIMEZONE = "America/Denver"
DEFAULT_LANG = "en"

PLUGINS = ["render_math"]

THEME = "theme/mathhub"
THEME_STATIC_PATHS = ["static"]
THEME_STATIC_DIR = "theme"

# Make sure Pelican treats .md files as content
MARKUP = ("md", "rst")

# Enable the Markdown "meta" extension so lines like "Title: ..." are parsed
MARKDOWN = {
    "extensions": [
        "markdown.extensions.extra",
        "markdown.extensions.codehilite",
        "markdown.extensions.meta",
    ],
    "extension_configs": {
        "markdown.extensions.codehilite": {"css_class": "highlight"},
    },
    "output_format": "html5",
}
# Top menu (use relative links so project-pages work)
MENUITEMS = [
    ("Home", "index.html"),
    ("Syllabus", "syllabus.html"),
    ("Calendar", "calendar.html"),
    ("SageMath", "sagemath.html"),
]
# If you prefer not to put Save_as in each page front-matter:
# (uncomment these two lines)
# PAGE_URL = "{slug}.html"
# PAGE_SAVE_AS = "{slug}.html"

EXTRA_PATH_METADATA = {"extra/favicon.ico": {"path": "favicon.ico"}}
#
# Content copied with the site (add more folders if needed)
STATIC_PATHS = ["static", "images", "extra/favicon.ico"]

COURSE_META = [
    "Instructor: Katherine E. Stange",
    "Office hours: TBA",
    "Contact: TBA",
]
SHOW_LATEST_POSTS = 0

# Feeds off during dev
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Optional housekeeping
DEFAULT_PAGINATION = False
RELATIVE_URLS = True           # important for local dev
DELETE_OUTPUT_DIRECTORY = True # avoids stale CSS/files in output/
DISPLAY_PAGES_ON_MENU = False  # since you're using MENUITEMS
