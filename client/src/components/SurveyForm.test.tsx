import { render, screen, fireEvent } from "@testing-library/react";
import SurveyForm from "./SurveyForm";
import axios from "axios";

jest.mock("axios");
const mockedAxios = axios as jest.Mocked<typeof axios>;

describe("SurveyForm Component", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it("should show error if any field is empty upon submission", async () => {
    render(<SurveyForm />);
    fireEvent.click(screen.getByText("Submit"));
    expect(
      await screen.findByText("Please answer all questions.")
    ).toBeInTheDocument();
  });

  it("should submit form successfully if all fields are filled", async () => {
    mockedAxios.post.mockResolvedValueOnce({ status: 200 });
    render(<SurveyForm />);

    fireEvent.change(screen.getByLabelText(/How are you feeling today?/), {
      target: { value: "3" },
    });
    fireEvent.change(screen.getByLabelText(/Rate your stress level from 1-5/), {
      target: { value: "3" },
    });
    fireEvent.change(screen.getByLabelText(/Any additional comments?/), {
      target: { value: "No comments" },
    });

    fireEvent.click(screen.getByText("Submit"));

    expect(mockedAxios.post).toHaveBeenCalledWith(`${import.meta.env.VITE_BACKEND_URL}/survey_responses`, {
      survey_response: {
        response: [
          {
            questionId: 1,
            response: "Good",
          },
          {
            questionId: 2,
            response: 3,
          },
          {
            questionId: 3,
            response: "No comments",
          },
        ],
      },
    });
    await screen.findByText("Thank you for your feedback!");
  });

  it("should display error if API call fails", async () => {
    mockedAxios.post.mockRejectedValueOnce(new Error("Network Error"));
    render(<SurveyForm />);

    fireEvent.change(screen.getByLabelText(/How are you feeling today?/), {
      target: { value: "2" },
    });
    fireEvent.change(screen.getByLabelText(/Rate your stress level from 1-5/), {
      target: { value: "4" },
    });
    fireEvent.change(screen.getByLabelText(/Any additional comments?/), {
      target: { value: "Some comments" },
    });

    fireEvent.click(screen.getByText("Submit"));

    expect(mockedAxios.post).toHaveBeenCalledWith(
      `${import.meta.env.VITE_BACKEND_URL}/survey_responses`,
      {
        survey_response: {
          response: [
            {
              questionId: 1,
              response: "Fine",
            },
            {
              questionId: 2,
              response: 4,
            },
            {
              questionId: 3,
              response: "Some comments",
            },
          ],
        },
      }
    );
    await screen.findByText("Submission failed. Please try again.");
  });
});
