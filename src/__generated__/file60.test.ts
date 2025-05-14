
import { getFile60Message } from "./file60";
import { expect } from "chai";

describe("file60 Tests", () => {
    it("should return the correct message", () => {
        const message = getFile60Message();
        expect(message).to.equal("Hello from file60!");
    });
});
