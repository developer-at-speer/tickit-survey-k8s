import React, { useState } from 'react';
import axios from 'axios';

export default function SurveyForm() {
  const [feeling, setFeeling] = useState<string | number>(0);
  const [stressLevel, setStressLevel] = useState<number>(0);
  const [comments, setComments] = useState<string>('');
  const [error, setError] = useState<string | null>(null);
  const [isSubmitted, setIsSubmitted] = useState<boolean>(false);
  const feelingLabels = ['Very Bad', 'Bad', 'Fine', 'Good', 'Very Good'];

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setIsSubmitted(false);

    if (!feeling || !stressLevel || !comments) {
      setError('Please answer all questions.');
      return;
    }

    const body = {
      survey_response: {
        response: [
          {
            questionId: 1,
            response: feelingLabels[Number(feeling)],
          },
          {
            questionId: 2,
            response: stressLevel,
          },
          {
            questionId: 3,
            response: comments,
          },
        ],
      },
    };

    try {
      await axios.post(`${import.meta.env.VITE_BACKEND_URL}/survey_responses`, body);
      setIsSubmitted(true);
    } catch (error) {
      setError('Submission failed. Please try again.');
    }
  };

  return (
    <form
      onSubmit={handleSubmit}
      className='w-[600px] mx-auto my-auto p-6 bg-white rounded align-middle max-h-fit rounded-lg'
    >
      <p className='text-gray-700 mb-2 text-lg font-bold'>Survey Form</p>
      <div className='relative mb-8'>
        <label htmlFor='feeling' className='block text-gray-700'>
          How are you feeling today?
        </label>
        <input
          id='feeling'
          name='feeling'
          value={feeling}
          onChange={(e) => setFeeling(e.target.value)}
          type='range'
          min={0}
          max={4}
          step={1}
          className='w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-indigo-500'
        />
        <div>
          <span className='text-sm text-gray-500 absolute start-0 -ml-3'>
            Very Bad
          </span>
          <span className='text-sm text-gray-500 absolute start-1/4 -ml-2'>
            Bad
          </span>
          <span className='text-sm text-gray-500 absolute start-1/2 -ml-3'>
            Fine
          </span>
          <span className='text-sm text-gray-500 absolute start-3/4 -ml-5'>
            Good
          </span>
          <span className='text-sm text-gray-500 absolute end-0 -mr-3'>
            Very Good
          </span>
        </div>
      </div>

      <div className='mb-4'>
        <label htmlFor='stressLevel' className='block text-gray-700'>
          Rate your stress level from 1-5
          <select
            id='stressLevel'
            name='stressLevel'
            value={stressLevel}
            onChange={(e) => setStressLevel(Number(e.target.value))}
            className='mt-2 p-2 border rounded w-full'
          >
            <option value={0} disabled>
              Select stress level
            </option>
            <option value={1}>1 - Very Low</option>
            <option value={2}>2 - Low</option>
            <option value={3}>3 - Moderate</option>
            <option value={4}>4 - High</option>
            <option value={5}>5 - Very High</option>
          </select>
        </label>
      </div>

      <div className='mb-4'>
        <label htmlFor='comments' className='block text-gray-700'>
          Any additional comments?
          <textarea
            id='comments'
            name='comments'
            value={comments}
            onChange={(e) => setComments(e.target.value)}
            className='mt-2 p-2 border rounded w-full'
          />
        </label>
      </div>

      {error && <p className='text-red-500'>{error}</p>}
      {isSubmitted && (
        <p className='text-green-500'>Thank you for your feedback!</p>
      )}

      <button
        type='submit'
        className='bg-indigo-500 hover:bg-indigo-700 text-white p-2 rounded mt-4 w-full'
      >
        Submit
      </button>
    </form>
  );
}
