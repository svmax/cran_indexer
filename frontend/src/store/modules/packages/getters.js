import { waitingGetters } from 'store-mixins/waiting-mixin';
import { ensurePaginableGetters } from 'store-mixins/paginable-mixin';

export default {
  ...waitingGetters,

  getGeneralInfo: state => state.generalInfo || {},

  ...ensurePaginableGetters('enumerable'),
};