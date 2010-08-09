# Path where projects are going to be saved
DATA_PATH = File.expand_path(File.join(BASE_PATH,'../','guidata'))

PRIVATE_DATA_PATH = File.expand_path(File.join(BASE_PATH,'../','guidata','private'))

# Folder containing commands configuration
COMMAND_CONFIG = File.expand_path(File.join(CONFIG_PATH,'commands'))


USER_SCRIPTS_PATH = File.expand_path(File.join(CONFIG_PATH,'scripts'))
STAGES_PATTERN = 'stage*.json'

# Standard attributes are saved in a file with this name
STANDARD_ATTR_JSON = 'std_attr.json'


GET_JOBINFO_SCRIPT = 'get_job_info.rb'

JOBLIST_TITLES_JSON = 'joblist_titles.json'

COMMAND_SWITCHES_TAG = '$COMMAND_SWITCHES'

DEFAULT_COMMAND = 'mira'
