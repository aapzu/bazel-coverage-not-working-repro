
import { getFile90Message } from "./file90";
import { expect } from "chai";

describe("file90 Tests", () => {
    it("should return the correct message", () => {
        const message = getFile90Message();
        expect(message).to.equal("Hello from file90!");
    });
});
