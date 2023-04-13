import * as admin from "firebase-admin";
admin.initializeApp();

/* eslint-disable max-len */
import standardGameAssignRoles = require("./standardGameAssignRoles");
exports.standardGameAssignRoles = standardGameAssignRoles.standardGameAssignRoles;

import standardGameExchangePhotoUrl = require("./standardGameExchangePhotoUrl");
exports.standardGameExchangePhotoUrl = standardGameExchangePhotoUrl.standardGameExchangePhotoUrl;

import standardGameCalculateResult = require("./standardGameCalculateResult");
exports.standardGameCalculateResult = standardGameCalculateResult.standardGameCalculateResult;
/* eslint-enable max-len */
