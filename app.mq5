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
input datetime fromDate = D'01.01.2022';
input datetime toDate = D'30.12.2022';
input string dataFilename = "datasource.json";

bool loadHistoryData(MqlRates& historyData[]){
   bool copyRatesStatus = CopyRates(Symbol(), PERIOD_D1, fromDate, toDate, historyData);
   
   if (copyRatesStatus == true) {
      Alert("Data successfully retrieved");
      return true;
   }else{
      Alert("Unable to retrieve data");
      return false;
   }
}

uint writeToJsonFile(int& file_handler, MqlRates& historyData[]) {
   uint writeCounter = 0;
   string jsonData = "";
   
   jsonData += "{ \"Time Series FX(Daily)\": \r\n";
   jsonData += "{\r\n";
   
   for(int counter = 0; counter < ArraySize(historyData); counter++){
      MqlDateTime dateStruct;
      TimeToStruct(historyData[counter].time, dateStruct);
      
      string properDate = dateStruct.year + "-" + dateStruct.mon + "-" + dateStruct.day;
       
      jsonData += "\"" + properDate + "\": {\r\n";
      //jsonData += "     \"Symbol\": \"" + Symbol() + "\",\r\n";
      jsonData += "     \"1. open\": \"" + (string)historyData[counter].open + "\",\r\n";
      jsonData += "     \"4. close\": \"" + (string)historyData[counter].close + "\",\r\n";
      jsonData += "     \"2. high\": \"" + (string)historyData[counter].high + "\",\r\n";
      jsonData += "     \"3. low\": \"" + (string)historyData[counter].low + "\",\r\n";
      jsonData += "  },\r\n"; 
   }
   
   jsonData += "}\n}\r\n";
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
 
   if (loadHistoryData(historyData)){
      addDataToJsonFile(historyData);
   }
   
   //Alert("Total Elements is : ", ArraySize(historyData));
}

