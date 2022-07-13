class LWCE_XGRecapSaveData extends XGRecapSaveData;

function RecordEvent(string EventText)
{
    // XCOM records text logs of many events throughout the game, which are persisted and end up bloating
    // the save file. We just no-op this function to prevent that, since the logs are only accessible via
    // a console command anyway.
}