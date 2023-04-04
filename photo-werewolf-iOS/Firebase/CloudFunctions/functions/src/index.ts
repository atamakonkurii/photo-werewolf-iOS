import * as admin from "firebase-admin";
admin.initializeApp();

/* eslint-disable max-len */
import standardGameAssignRoles = require("./standardGameAssignRoles");
import standardGameExchangePhotoUrl = require("./standardGameExchangePhotoUrl");
exports.standardGameAssignRoles = standardGameAssignRoles.standardGameAssignRoles;
exports.standardGameExchangePhotoUrl = standardGameExchangePhotoUrl.standardGameExchangePhotoUrl;
/* eslint-enable max-len */
