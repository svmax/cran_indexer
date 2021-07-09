import index from 'views/packages/index';
import show from 'views/packages/show';

export default () => {
  return {
    mode: 'history',
    routes: [
      {
        name: 'packages',
        path: '/',
        component: index,
      },
      {
        name: 'packagesVersions',
        path: '/packages/:id',
        component: show,
      },
    ],
  };
};
