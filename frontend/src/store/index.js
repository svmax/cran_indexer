import packages from './modules/packages';

export default {
  modules: {
    packages,
  },

  strict: process.env.NODE_ENV !== 'production',
};
