import { ensurePaginableFormat } from 'store/modules/mixins/paginable-mixin';
import { RECEIVE_PACKAGES, RECEIVE_PACKAGE_WITH_VERSIONS } from './types';
import { waitingMutations } from 'store-mixins/waiting-mixin';

export default {
  ...waitingMutations,

  [RECEIVE_PACKAGES] (state, payload) {
    state.enumerable = ensurePaginableFormat(payload);
  },

  [RECEIVE_PACKAGE_WITH_VERSIONS] (state, payload) {
    state.generalInfo = payload;
  },
};