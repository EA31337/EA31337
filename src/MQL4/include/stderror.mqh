//+------------------------------------------------------------------+
//|                                                     stderror.mqh |
//|                   Copyright 2005-2015, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
//--- errors returned from trade server
#define ERR_NO_ERROR                                  0
#define ERR_NO_RESULT                                 1
#define ERR_COMMON_ERROR                              2
#define ERR_INVALID_TRADE_PARAMETERS                  3
#define ERR_SERVER_BUSY                               4
#define ERR_OLD_VERSION                               5
#define ERR_NO_CONNECTION                             6
#define ERR_NOT_ENOUGH_RIGHTS                         7
#define ERR_TOO_FREQUENT_REQUESTS                     8
#define ERR_MALFUNCTIONAL_TRADE                       9
#define ERR_ACCOUNT_DISABLED                         64
#define ERR_INVALID_ACCOUNT                          65
#define ERR_TRADE_TIMEOUT                           128
#define ERR_INVALID_PRICE                           129
#define ERR_INVALID_STOPS                           130
#define ERR_INVALID_TRADE_VOLUME                    131
#define ERR_MARKET_CLOSED                           132
#define ERR_TRADE_DISABLED                          133
#define ERR_NOT_ENOUGH_MONEY                        134
#define ERR_PRICE_CHANGED                           135
#define ERR_OFF_QUOTES                              136
#define ERR_BROKER_BUSY                             137
#define ERR_REQUOTE                                 138
#define ERR_ORDER_LOCKED                            139
#define ERR_LONG_POSITIONS_ONLY_ALLOWED             140
#define ERR_TOO_MANY_REQUESTS                       141
#define ERR_TRADE_MODIFY_DENIED                     145
#define ERR_TRADE_CONTEXT_BUSY                      146
#define ERR_TRADE_EXPIRATION_DENIED                 147
#define ERR_TRADE_TOO_MANY_ORDERS                   148
#define ERR_TRADE_HEDGE_PROHIBITED                  149
#define ERR_TRADE_PROHIBITED_BY_FIFO                150
//--- mql4 run time errors
#define ERR_NO_MQLERROR                            4000
#define ERR_WRONG_FUNCTION_POINTER                 4001
#define ERR_ARRAY_INDEX_OUT_OF_RANGE               4002
#define ERR_NO_MEMORY_FOR_CALL_STACK               4003
#define ERR_RECURSIVE_STACK_OVERFLOW               4004
#define ERR_NOT_ENOUGH_STACK_FOR_PARAM             4005
#define ERR_NO_MEMORY_FOR_PARAM_STRING             4006
#define ERR_NO_MEMORY_FOR_TEMP_STRING              4007
#define ERR_NOT_INITIALIZED_STRING                 4008
#define ERR_NOT_INITIALIZED_ARRAYSTRING            4009
#define ERR_NO_MEMORY_FOR_ARRAYSTRING              4010
#define ERR_TOO_LONG_STRING                        4011
#define ERR_REMAINDER_FROM_ZERO_DIVIDE             4012
#define ERR_ZERO_DIVIDE                            4013
#define ERR_UNKNOWN_COMMAND                        4014
#define ERR_WRONG_JUMP                             4015
#define ERR_NOT_INITIALIZED_ARRAY                  4016
#define ERR_DLL_CALLS_NOT_ALLOWED                  4017
#define ERR_CANNOT_LOAD_LIBRARY                    4018
#define ERR_CANNOT_CALL_FUNCTION                   4019
#define ERR_EXTERNAL_CALLS_NOT_ALLOWED             4020
#define ERR_NO_MEMORY_FOR_RETURNED_STR             4021
#define ERR_SYSTEM_BUSY                            4022
#define ERR_DLLFUNC_CRITICALERROR                  4023
#define ERR_INTERNAL_ERROR                         4024   // new MQL4
#define ERR_OUT_OF_MEMORY                          4025   // new MQL4
#define ERR_INVALID_POINTER                        4026   // new MQL4
#define ERR_FORMAT_TOO_MANY_FORMATTERS             4027   // new MQL4
#define ERR_FORMAT_TOO_MANY_PARAMETERS             4028   // new MQL4
#define ERR_ARRAY_INVALID                          4029   // new MQL4
#define ERR_CHART_NOREPLY                          4030   // new MQL4
#define ERR_INVALID_FUNCTION_PARAMSCNT             4050
#define ERR_INVALID_FUNCTION_PARAMVALUE            4051
#define ERR_STRING_FUNCTION_INTERNAL               4052
#define ERR_SOME_ARRAY_ERROR                       4053
#define ERR_INCORRECT_SERIESARRAY_USING            4054
#define ERR_CUSTOM_INDICATOR_ERROR                 4055
#define ERR_INCOMPATIBLE_ARRAYS                    4056
#define ERR_GLOBAL_VARIABLES_PROCESSING            4057
#define ERR_GLOBAL_VARIABLE_NOT_FOUND              4058
#define ERR_FUNC_NOT_ALLOWED_IN_TESTING            4059
#define ERR_FUNCTION_NOT_CONFIRMED                 4060
#define ERR_SEND_MAIL_ERROR                        4061
#define ERR_STRING_PARAMETER_EXPECTED              4062
#define ERR_INTEGER_PARAMETER_EXPECTED             4063
#define ERR_DOUBLE_PARAMETER_EXPECTED              4064
#define ERR_ARRAY_AS_PARAMETER_EXPECTED            4065
#define ERR_HISTORY_WILL_UPDATED                   4066
#define ERR_TRADE_ERROR                            4067
#define ERR_RESOURCE_NOT_FOUND                     4068   // new MQL4
#define ERR_RESOURCE_NOT_SUPPORTED                 4069   // new MQL4
#define ERR_RESOURCE_DUPLICATED                    4070   // new MQL4
#define ERR_INDICATOR_CANNOT_INIT                  4071   // new MQL4
#define ERR_INDICATOR_CANNOT_LOAD                  4072   // new MQL4
#define ERR_NO_HISTORY_DATA                        4073   // new MQL4
#define ERR_NO_MEMORY_FOR_HISTORY                  4074   // new MQL4
#define ERR_END_OF_FILE                            4099
#define ERR_SOME_FILE_ERROR                        4100
#define ERR_WRONG_FILE_NAME                        4101
#define ERR_TOO_MANY_OPENED_FILES                  4102
#define ERR_CANNOT_OPEN_FILE                       4103
#define ERR_INCOMPATIBLE_FILEACCESS                4104
#define ERR_NO_ORDER_SELECTED                      4105
#define ERR_UNKNOWN_SYMBOL                         4106
#define ERR_INVALID_PRICE_PARAM                    4107
#define ERR_INVALID_TICKET                         4108
#define ERR_TRADE_NOT_ALLOWED                      4109
#define ERR_LONGS_NOT_ALLOWED                      4110
#define ERR_SHORTS_NOT_ALLOWED                     4111
#define ERR_OBJECT_ALREADY_EXISTS                  4200
#define ERR_UNKNOWN_OBJECT_PROPERTY                4201
#define ERR_OBJECT_DOES_NOT_EXIST                  4202
#define ERR_UNKNOWN_OBJECT_TYPE                    4203
#define ERR_NO_OBJECT_NAME                         4204
#define ERR_OBJECT_COORDINATES_ERROR               4205
#define ERR_NO_SPECIFIED_SUBWINDOW                 4206
#define ERR_SOME_OBJECT_ERROR                      4207
#define ERR_CHART_PROP_INVALID                     4210   // new MQL4
#define ERR_CHART_NOT_FOUND                        4211   // new MQL4
#define ERR_CHARTWINDOW_NOT_FOUND                  4212   // new MQL4
#define ERR_CHARTINDICATOR_NOT_FOUND               4213   // new MQL4
#define ERR_SYMBOL_SELECT                          4220   // new MQL4
#define ERR_NOTIFICATION_ERROR                     4250
#define ERR_NOTIFICATION_PARAMETER                 4251
#define ERR_NOTIFICATION_SETTINGS                  4252
#define ERR_NOTIFICATION_TOO_FREQUENT              4253
#define ERR_FILE_TOO_MANY_OPENED                   5001   // new MQL4
#define ERR_FILE_WRONG_FILENAME                    5002   // new MQL4
#define ERR_FILE_TOO_LONG_FILENAME                 5003   // new MQL4
#define ERR_FILE_CANNOT_OPEN                       5004   // new MQL4
#define ERR_FILE_BUFFER_ALLOCATION_ERROR           5005   // new MQL4
#define ERR_FILE_CANNOT_DELETE                     5006   // new MQL4
#define ERR_FILE_INVALID_HANDLE                    5007   // new MQL4
#define ERR_FILE_WRONG_HANDLE                      5008   // new MQL4
#define ERR_FILE_NOT_TOWRITE                       5009   // new MQL4
#define ERR_FILE_NOT_TOREAD                        5010   // new MQL4
#define ERR_FILE_NOT_BIN                           5011   // new MQL4
#define ERR_FILE_NOT_TXT                           5012   // new MQL4
#define ERR_FILE_NOT_TXTORCSV                      5013   // new MQL4
#define ERR_FILE_NOT_CSV                           5014   // new MQL4
#define ERR_FILE_READ_ERROR                        5015   // new MQL4
#define ERR_FILE_WRITE_ERROR                       5016   // new MQL4
#define ERR_FILE_BIN_STRINGSIZE                    5017   // new MQL4
#define ERR_FILE_INCOMPATIBLE                      5018   // new MQL4
#define ERR_FILE_IS_DIRECTORY                      5019   // new MQL4
#define ERR_FILE_NOT_EXIST                         5020   // new MQL4
#define ERR_FILE_CANNOT_REWRITE                    5021   // new MQL4
#define ERR_FILE_WRONG_DIRECTORYNAME               5022   // new MQL4
#define ERR_FILE_DIRECTORY_NOT_EXIST               5023   // new MQL4
#define ERR_FILE_NOT_DIRECTORY                     5024   // new MQL4
#define ERR_FILE_CANNOT_DELETE_DIRECTORY           5025   // new MQL4
#define ERR_FILE_CANNOT_CLEAN_DIRECTORY            5026   // new MQL4
#define ERR_FILE_ARRAYRESIZE_ERROR                 5027   // new MQL4
#define ERR_FILE_STRINGRESIZE_ERROR                5028   // new MQL4
#define ERR_FILE_STRUCT_WITH_OBJECTS               5029   // new MQL4
