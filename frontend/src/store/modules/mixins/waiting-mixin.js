export const START_WAITING = 'START_WAITING';
export const STOP_WAITING = 'STOP_WAITING';

export const waitingState = {
  waiting: false,
};

export const waitingMutations = {
  [START_WAITING] (state) {
    state.waiting = true;
  },

  [STOP_WAITING] (state) {
    state.waiting = false;
  },
};

export const waitingGetters = {
  isWaiting: state => state.waiting,
};
