//+------------------------------------------------------------------+
//|                                                          app.mq5 |
//|                                                  Given Makhobela |
//|                                      https://github.com/gmakhobe |
//+------------------------------------------------------------------+
#property copyright "Given Makhobela"
#property link      "https://github.com/gmakhobe"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

input string dataDiractoryName = "Data";
input datetime fromDate = D'01.01.2021';
input datetime toDate = D'30.12.2021';
input string dataFilename = "datasource.json";

void loadHistoryData(MqlRates& historyData[]){
   int copyRatesStatus = CopyRates(Symbol(), PERIOD_H1, fromDate, toDate, historyData);
   
   if (copyRatesStatus <= 0) {
      Alert("Unable to retrieve data");
   }else{
      Alert("Data successfully retrieved");
   }
}

uint writeToJsonFile(int& file_handler, MqlRates& historyData[]) {
   uint writeCounter = 0;
   string jsonData = "";
   
   jsonData += "{\r\n";
   
   for(int counter = 0; counter < ArraySize(historyData); counter++){
      
      jsonData += "  {\r\n";
      jsonData += "     \"Symbol\": \"" + Symbol() + "\",\r\n";
      jsonData += "     \"Open\": " + (string)historyData[counter].open + ",\r\n";
      jsonData += "     \"Close\": " + (string)historyData[counter].close + ",\r\n";
      jsonData += "     \"high\": " + (string)historyData[counter].high + ",\r\n";
      jsonData += "     \"low\": " + (string)historyData[counter].low + ",\r\n";
      jsonData += "     \"time\": \"" + (string)historyData[counter].time + "\"\r\n";
      jsonData += "  }\r\n"; 
   }
   
   jsonData += "}\r\n";
   writeCounter = FileWriteString(file_handler, jsonData);
   return writeCounter;
}

void addDataToJsonFile(MqlRates& historyData[]){
  
  int file_handler = FileOpen(dataDiractoryName + "//" + dataFilename, FILE_READ|FILE_WRITE|FILE_BIN|FILE_COMMON);
  uint writeStatus = 0;

  if (file_handler != INVALID_HANDLE) {
      //Alert("File opened successfully");
      writeStatus = writeToJsonFile(file_handler, historyData);
      FileClose(file_handler);
  }else{
      Alert("File failed to open!");
  }
  
  if(writeStatus != 0){
   Alert("Added data to data file successfully!");
  }else
  {
   Alert("Data was not added to a file!");    
  }
}

void OnStart()
{

   MqlRates historyData[];
 
   loadHistoryData(historyData);
   addDataToJsonFile(historyData);
   
   //Alert("Total Elements is : ", ArraySize(historyData));
}

