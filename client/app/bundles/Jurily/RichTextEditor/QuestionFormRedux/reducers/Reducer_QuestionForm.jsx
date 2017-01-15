import actionTypes from '../constants/action-types';

export default function (state = {}, action) {
  switch (action.type) {
    case actionTypes.SUBMIT_FORM_PENDING:
      return {
        ...state,
        submissionPending: true,
        errors: [],
        response: {}
      };
    case actionTypes.SUBMIT_FORM_ERROR:
      return {
        submissionPending: false,
        errors: ['Error submitting question.'],
        response: {}
      };
    case actionTypes.SUBMIT_FORM_SUCCESS:
      return {
        submissionPending: false,
        errors: [],
        response: action.response
      };
    default:
      return state;
  }
}