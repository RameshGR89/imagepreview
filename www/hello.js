/*global cordova, module*/

module.exports = {
    openGallary: function (arrImages, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ImagePreview", "openGallary", [arrImages]);
    }
};
