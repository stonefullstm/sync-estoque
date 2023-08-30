// source: https://www.linkedin.com/pulse/setting-up-rtl-vite-react-project-william-ku/

import { render } from "@testing-library/react";

const customRender = (ui, options = {}) =>

  render(ui, {

    // wrap provider(s) here if needed

    wrapper: ({ children }) => children,

    ...options,

  });


export * from "@testing-library/react";

export { default as userEvent } from "@testing-library/user-event";

// override render export

export { customRender as render };