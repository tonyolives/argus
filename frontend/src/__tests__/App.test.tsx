import { render, screen } from '@testing-library/react';

import App from '../App';

describe('App', () => {
  it('renders the frontend shell copy for the sprint 1 scaffold', () => {
    render(<App />);

    expect(screen.getByText('ARGUS')).toBeInTheDocument();
    expect(
      screen.getByRole('heading', {
        name: /real-time global osint monitoring/i,
      }),
    ).toBeInTheDocument();
    expect(
      screen.getByText(/sprint 1 scaffolds the frontend shell/i),
    ).toBeInTheDocument();
  });

  it('renders the placeholder globe viewport', () => {
    render(<App />);

    expect(
      screen.getByRole('region', {
        name: /argus globe viewport/i,
      }),
    ).toBeInTheDocument();
  });
});
