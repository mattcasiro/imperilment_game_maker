# Difficulty can be set to :easy, :medium, or :hard with this constant.
#   easy:
#     - One category from single jeopardy, one category from double jeopardy
#     - First three valid clues from each category
#
#   medium:
#     - One category from single jeopardy, one category from double jeopardy
#     - Last three valid clues from each category
#
#   hard:
#     - Two categories from double jeopardy
#     - Last three valid clues from each category
DIFFICULTY = :medium

# Season exclusion based on year can be set with this constant.
#   - Designate how many seasons to include (from most recent)
#   - If the number is > the number of seasons, all seasons are included
#   - :all can be used to always include all seasons
SEASONS = 15

# It is NOT recommended to change these constants!
FIXTURE_PATH = 'spec/fixtures/'
WEB_PATH = 'imperilment.stembolt.com'
LINK_STR = "a href="
VDD_STR = "[Video Daily Double]"
TOKEN_REGEX = "//meta[@name='csrf-token']"
