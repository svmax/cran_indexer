import { RECEIVE_PACKAGES, RECEIVE_PACKAGE_WITH_VERSIONS } from './types';
import { START_WAITING, STOP_WAITING } from 'store-mixins/waiting-mixin';
import { receivePackagesRequest, receivePackageWithVersionsRequest } from './api';
import { canMakeNewPaginableRequest } from 'store/modules/mixins/paginable-mixin';

export default {
  async receivePackages({ state, commit }, payload = {}) {
    const canContinue = await canMakeNewPaginableRequest(state.enumerable, payload);
    if (!canContinue) return null;

    try {
      await commit(START_WAITING);
      const { data } = await receivePackagesRequest(payload);
      await commit(RECEIVE_PACKAGES, data);
    } catch (error) {
      console.log(error.message);
    } finally {
      await commit(STOP_WAITING);
    }
  },

  async receivePackageWithVersions({ commit }, payload = {}) {
    try {
      await commit(START_WAITING);
      const { data } = await receivePackageWithVersionsRequest(payload);
      await commit(RECEIVE_PACKAGE_WITH_VERSIONS, data);
    } catch (error) {
      console.log(error.message);
    } finally {
      await commit(STOP_WAITING);
    }
  },
};