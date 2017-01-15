import axios from 'axios';

import actionTypes from '../constants/action-types';
import paths from '../constants/api-endpoints';

export function submitFormSuccess(response) {
  window.location.href = response.forwardingUrl;
  return {
    type: actionTypes.SUBMIT_FORM_SUCCESS,
    response
  };
}

export function submitFormError(error) {
  return {
    type: actionTypes.SUBMIT_FORM_ERROR,
    error
  }
}


export function submitFormPending() {
  return {
    type: actionTypes.SUBMIT_FORM_PENDING
  }
}

export function submitForm(data) {
  const {form, csrfToken, question} = data;
  const requestDetail = getDetail(question.id);
  //todo - improve to use full url rather than merely path.
  return dispatch => {
    dispatch(submitFormPending());
    return axios[requestDetail.method](requestDetail.url, form, {
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      }
    }).then(response => {
      dispatch(submitFormSuccess(response.data));
    }).catch(error => {
      console.log(error);
      dispatch(submitFormError(error));
    });
  }
}

function getDetail(questionId) {
  if (!questionId) return {url:paths.CREATE_QUESTION,method:'post'};
  else return {url:`${paths.UPDATE_QUESTION}${questionId}`, method:'put'};
}

