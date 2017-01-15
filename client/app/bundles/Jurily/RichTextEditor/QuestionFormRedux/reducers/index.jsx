import {combineReducers} from 'redux';
import Reducer_QuestionForm from './Reducer_QuestionForm';

const rootReducer = combineReducers({
  questionForm: Reducer_QuestionForm,
});

export default rootReducer;

