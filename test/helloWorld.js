const HelloWorld = artifacts.require("HelloWorld");

contract("HelloWorld", () => {
  it("Hello World Testing", async () => {
    const hw = await HelloWorld.deployed();
    await hw.setName("User Name");
    const result = await hw.yourName();
    assert(result === "User Name");
  });
});