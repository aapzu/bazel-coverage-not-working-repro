
import { getFile120Message } from "./file120";
import { expect } from "chai";

describe("file120 Tests", () => {
    it("should return the correct message", () => {
        const message = getFile120Message();
        expect(message).to.equal("Hello from file120!");
    });
});
