import { values, upperFirst, isEqual } from 'lodash';

export const ensurePaginableStateFields = () => ({
  nextCursor: null,
  page: null,
  per: null,
  total: 0,
  items: {},
});

export const canMakeNewPaginableRequest = (state, payload) => {
  const { per, page, nextCursor } = state;
  const nextPer = payload.per;
  const nextPage = payload.page;

  if (nextCursor)
    return true;

  return !isEqual([per, page], [nextPer, nextPage]);
};

export const ensurePaginableGetters = namespace => {
  let getters = {};
  const name = upperFirst(namespace);

  getters[`get${name}Items`] = state => values(state[namespace].items);
  getters[`get${name}Total`] = state => state[namespace].total;
  getters[`get${name}NextCursor`] = state => state[namespace].nextCursor;

  return getters;
};

export const ensurePaginableFormat = payload => {
  let data = typeof payload == 'string' ? JSON.parse(payload) : payload;
  const { per, page, total, items, nextCursor } = data;
  return { per, page, total, items, nextCursor };
};