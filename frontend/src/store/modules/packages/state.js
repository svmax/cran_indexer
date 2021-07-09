import { waitingState } from 'store-mixins/waiting-mixin';
import { ensurePaginableStateFields } from 'store-mixins/paginable-mixin';

export default {
  ...waitingState,
  enumerable: ensurePaginableStateFields(),
  generalInfo: {},
};