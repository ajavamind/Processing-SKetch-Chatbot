// Configuration from JSON file
// config.json is the default file - do not change config.json

import java.time.*;
import java.time.Instant;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.LocalDateTime;

String configFolderName = "config";
String defaultConfigFileName = "envConfig.json";  // working parameters read and write
String chatConfigFileName = "chatConfig.json"; // AI client parameters read only
static final String saveFolder = "output"; // default output folder location relative to sketch path until changed by "Save Folder" menu button
String saveFolderPath; // full path to save folder

JSONObject configFile;
JSONObject configParameters;
JSONObject chatConfigFile;
JSONObject chatParameters;

/**
 * initialize Chatbot from its configuration files
 */
int initConfig(int num) {
  int result;
  if (num == 0)
    result = readEnvConfig(sketchPath() + File.separator + configFolderName+ File.separator + defaultConfigFileName);
  else
    result = readChatConfig(sketchPath() + File.separator + configFolderName+ File.separator + chatConfigFileName);
  return result;
}

/**
 * read configuration file from filenamePath
 * return -2 if invalid json parameters
 * return -1 if config file read error
 * return 0 if read config file successful
 */
int readEnvConfig(String filenamePath) {
  logger("readEnvConfig "+ filenamePath);
  if (!fileExists(filenamePath)) {
    return -1;
  }
  try {
    configFile = loadJSONObject(filenamePath);
    configParameters = configFile.getJSONObject("parameters");
  }
  catch (Exception e) {
    return -2;
  }

  String temp = configParameters.getString("outputPath");
  if (!temp.equals("")) {
    saveFolderPath = configParameters.getString("outputPath");
  }
  logger("envConfig outputPath: " + saveFolderPath);
  return 0;
}

void updateSaveFolderPath() {
  configParameters.setString("outputPath", saveFolderPath);
  writeEnvConfig();
}

void writeEnvConfig() {
  saveJSONObject(configFile, configFolderName+ File.separator + defaultConfigFileName, "indent=2");
}

/**
 * read configuration file from filenamePath
 * return -2 if invalid json parameters
 * return -1 if config file read error
 * return 0 if read config file successful
 */
int readChatConfig(String filenamePath) {
  logger("readChatConfig "+ filenamePath);
  if (!fileExists(filenamePath)) {
    return -1;
  }
  try {
    chatConfigFile = loadJSONObject(filenamePath);
    chatParameters = chatConfigFile.getJSONObject("parameters");
  }
  catch (Exception e) {
    return -2;
  }

  model = chatParameters.getString("model");
  float temp = chatParameters.getFloat("temperature");
  temperature = (double) temp;
  temp = chatParameters.getFloat("topP");
  topP = (double) temp;
  timeout = chatParameters.getInt("timeout");
  logger("model="+model);
  logger("temperature="+temperature);
  logger("topP="+topP);
  logger("timeout="+timeout);
  return 0;
}


// Check if a file exists
boolean fileExists(String filenamePath) {
  File newFile = new File (filenamePath);
  if (newFile.exists()) {
    if (DEBUG) println("File "+ filenamePath+ " exists");
    return true;
  }
  return false;
}