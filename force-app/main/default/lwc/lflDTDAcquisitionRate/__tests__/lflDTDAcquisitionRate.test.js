import { createElement } from "lwc";
import LflDTDAcquisitionRate from "c/lflDTDAcquisitionRate";

describe("c-lfl-dtd-acquisition-rate", () => {
  afterEach(() => {
    // The jsdom instance is shared across test cases in a single file so reset the DOM
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });

  it("TODO: test case generated by CLI command, please fill in test logic", () => {
    // Arrange
    const element = createElement("c-lfl-dtd-acquisition-rate", {
      is: LflDTDAcquisitionRate
    });

    // Act
    document.body.appendChild(element);

    // Assert
    // const div = element.shadowRoot.querySelector('div');
    expect(1).toBe(1);
  });
});
