/**
 * Created by user on 08.08.2021.
 */
({
    onCreateDataset : function(component, event, helper) {
        helper.onCreateDataset(component);
    },
    onLoadDatasets : function(component, event, helper) {
        helper.onLoadDatasets(component);
    },
    onTrainDataset : function(component, event, helper) {
        helper.onTrainDataset(component, event);
    },
    onDeleteDataset : function(component, event, helper) {
        helper.onDeleteDataset(component, event);
    }
})