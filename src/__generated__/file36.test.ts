
import { getFile36Message } from "./file36";
import { expect } from "chai";

describe("file36 Tests", () => {
    it("should return the correct message", () => {
        const message = getFile36Message();
        expect(message).to.equal("Hello from file36!");
    });
});
