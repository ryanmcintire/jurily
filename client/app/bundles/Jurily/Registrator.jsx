import React from 'react';
import ReactOnRails from 'react-on-rails';

import AnswerForm from './RichTextEditor/AnswerForm';
import QuestionForm from './RichTextEditor/QuestionForm';
import VoteBox from './VoteBox/vote-box';

ReactOnRails.register({
  AnswerForm,
  QuestionForm,
  VoteBox
});