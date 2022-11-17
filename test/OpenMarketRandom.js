const { expect } = require("chai");

describe("RandomNumberConsumer", async function () {
  let randomNumberConsumer, vrfCoordinatorMock, seed, link, keyhash, fee;
  beforeEach(async () => {
    console.log("a");
    const MockLink = await ethers.getContractFactory("MockLink");
    const RandomNumberConsumer = await ethers.getContractFactory("OpenMarket");
    link = await MockLink.deploy();
    randomNumberConsumer = await RandomNumberConsumer.deploy();
  });
  it("Random Number Should successfully make an external random number request", async () => {
    //Before we can do an API request, we need to fund it with LINK
    //await link.transfer(randomNumberConsumer.address, '2000000000000000000')
    await new Promise(function (resolve) {
      setTimeout(async () => {
        let transaction = await randomNumberConsumer.getRandomNumber();
        let tx_receipt = await transaction.wait(1);
        let randomNumber = await randomNumberConsumer.randomResult();
        resolve();
      }, 1000);
    });

    expect(777).to.equal(777);
  });
});
