/*
 * Copyright Elasticsearch B.V. and/or licensed to Elasticsearch B.V. under one
 * or more contributor license agreements. Licensed under the Elastic License;
 * you may not use this file except in compliance with the Elastic License.
 */

import chrome from 'ui/chrome';
if (chrome.getInjected('indexLifecycleManagementUiEnabled')) {
  require('./register_index_lifecycle_actions');
  require('./register_index_lifecycle_banner');
  require('./register_index_lifecycle_summary');
}