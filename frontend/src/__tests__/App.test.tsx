jest.mock('react-globe.gl', () => ({
  __esModule: true,
  default: (props: Record<string, unknown>) => (
    <div
      data-testid="globe-canvas"
      data-globe-image-url={String(props.globeImageUrl)}
      data-background-color={String(props.backgroundColor)}
    />
  ),
}));

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
      screen.getByText(/track live air traffic, geopolitical incidents/i),
    ).toBeInTheDocument();
  });

  it('renders the globe viewport with an Earth texture on a dark background', () => {
    render(<App />);

    expect(
      screen.getByRole('region', {
        name: /argus globe viewport/i,
      }),
    ).toBeInTheDocument();

    const globeCanvas = screen.getByTestId('globe-canvas');
    expect(globeCanvas.getAttribute('data-globe-image-url')).toContain(
      'earth-night.jpg',
    );
    expect(globeCanvas).toHaveAttribute(
      'data-background-color',
      'rgba(0, 0, 0, 0)',
    );
  });
});
