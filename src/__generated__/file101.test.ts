
import { getFile101Message } from "./file101";
import { expect } from "chai";

describe("file101 Tests", () => {
    it("should return the correct message", () => {
        const message = getFile101Message();
        expect(message).to.equal("Hello from file101!");
    });
});
