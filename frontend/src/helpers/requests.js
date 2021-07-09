import axios from 'axios';
import { apiBaseUrl, apiNamespace } from 'helpers/constants';

const extractError = data => {
  let msg;
  if (Array.isArray(data))
    msg = data.join('; ');
  else if (typeof data === 'string')
    msg = data;
  else if (typeof data === 'object')
    msg = typeof data.error === 'object' ? data.error.message : data.error;
  else
    msg = 'Error!';

  throw new Error(msg);
};

export const apiRequest = async options => {
  const { url } = options;

  return await axios({...options, url: `${apiBaseUrl}/${apiNamespace}${url}`}).catch(error => {
    const { response } = error;
    if (!response) return error;
    const { status, data } = response;

    extractError(status >= 500 ? undefined : data);
  });
};

export const apiMutation = options => apiRequest({method: 'POST', ...options});
