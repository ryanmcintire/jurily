import React from 'react';
import {Provider} from 'react-redux';
import {createStore, applyMiddleware} from 'redux';
import thunk from 'redux-thunk';

import reducers from './reducers/index';

import QuestionFormContainer from './containers/QuestionFormContainer';

const QuestionFormRedux = (props, ctx) => {
  const {user, csrfToken, jurisdictions, question} = props;
  const initialState = {};
  const store = createStore(reducers, initialState, applyMiddleware(thunk), window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__());
  return (
    <Provider store={store}>
      <QuestionFormContainer
        user={user}
        csrfToken={csrfToken}
        jurisdictions={jurisdictions}
        question={question}
      />
    </Provider>
  );
};

export default QuestionFormRedux;