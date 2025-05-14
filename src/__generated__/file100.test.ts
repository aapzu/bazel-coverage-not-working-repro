
import { getFile100Message } from "./file100";
import { expect } from "chai";

describe("file100 Tests", () => {
    it("should return the correct message", () => {
        const message = getFile100Message();
        expect(message).to.equal("Hello from file100!");
    });
});
