import { apiRequest } from 'helpers/requests';

export const receivePackagesRequest = (data, options = {}) => apiRequest({
  url: '/packages',
  params: data,
  transformResponse: resp => {
    const data = JSON.parse(resp);

    return {
      per: data.per,
      page: data.page,
      total: data.total,
      items: data.items,
    };
  },
  ...options,
});

export const receivePackageWithVersionsRequest = (id, options = {}) => apiRequest({
  url: `/packages/${id}`,
  ...options,
});
