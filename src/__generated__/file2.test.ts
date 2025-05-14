
import { getFile2Message } from "./file2";
import { expect } from "chai";

describe("file2 Tests", () => {
    it("should return the correct message", () => {
        const message = getFile2Message();
        expect(message).to.equal("Hello from file2!");
    });
});
