/**
 * Created by user on 08.08.2021.
 */

public class EinsteinVision_Admin {
    private static String TOKEN = 'JIZUKNKCJEZFCTCSGZGUEQ2CIJEU6TCKIRIEOSBVJ5BEQUKQKVLU4U2KKRIFOSKTKVKEEQKIKZFTGSCHGNCDIVCSKBKVASKPJVFVGN2KKZGVQWBTJZIDMS2GKBNDOU2TGIZVOR2ZI5JU2NRXKU3DMM2XLAZEIMSTLFFUS7COIE';
    @AuraEnabled
    public static void createDatasetFromUrl(String zipUrl) {
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService(TOKEN);
        service.createDatasetFromUrlAsync(zipUrl);
    }
    @AuraEnabled
    public static List<EinsteinVision_Dataset> getDatasets() {
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService(TOKEN);
        EinsteinVision_Dataset[] datasets = service.getDatasets();
        System.debug(datasets);
        return datasets;
    }
    @AuraEnabled
    public static String trainDataset(Decimal datasetId) {
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService(TOKEN);
        EinsteinVision_Model model = service.trainDataset(Long.valueOf(String.valueOf(datasetId)), 'Training', 0, 0, '');
        return model.modelId;
    }
    @AuraEnabled
    public static void deleteDataset(Long datasetId) {
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService(TOKEN);
        service.deleteDataset(datasetId);
    }
    @AuraEnabled
    public static List<EinsteinVision_Model> getModels(Long datasetId) {
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService(TOKEN);
        EinsteinVision_Model[] models = service.getModels(datasetId);
        return models;
    }
    @AuraEnabled
    public static void getCatPrediction(Id catId, String fileName, String base64) {
        Blob fileBlob = EncodingUtil.base64Decode(base64);
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService(TOKEN);
        EinsteinVision_Dataset[] datasets = service.getDatasets();
        for (EinsteinVision_Dataset dataset : datasets) {
            if (dataset.Name.equals('Cats')) {
                EinsteinVision_Model[] models = service.getModels(dataset);
                EinsteinVision_Model model = models.get(0);
                EinsteinVision_PredictionResult result = service.predictBlob(model.modelId, fileBlob, '');
                EinsteinVision_Probability probability = result.probabilities.get(0);
                Cat__c cat = [SELECT Id FROM Cat__C WHERE Id=:catId];
                cat.Cat_Breed__c = probability.label;
                update cat;
                Attachment[] attsOld = [SELECT Id FROM Attachment WHERE ParentId=:catId];
                delete attsOld;
                Attachment att = new Attachment();
                att.Body = fileBlob;
                att.ParentId = cat.Id;
                att.Name = fileName;
                insert att;
            }
        }
    }
    @AuraEnabled
    public static List<EinsteinVision_Label> getCatLabels() {
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService(TOKEN);
        EinsteinVision_Dataset[] datasets = service.getDatasets();
        for (EinsteinVision_Dataset dataset : datasets) {
            if (dataset.Name.equals('Cats')) {
                return dataset.labelSummary.labels;
            }
        }
        return null;
    }
    @AuraEnabled
    public static String getImageUrlFromAttachment(Id catId) {
        List<Attachment> atts = [SELECT Id FROM Attachment WHERE ParentId=:catId];
        if (atts.size()>0) {
            return atts.get(0).Id;
        }
        return '';
    }
}