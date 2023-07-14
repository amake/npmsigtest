const sleep = (ms) => new Promise(r => setTimeout(r, ms));

(async () => {
  const handler = async (sig) => {
    console.log(sig, 'received; shutting down gracefully');
    for (let i = 0; i < 3; i++) {
      console.log('+');
      await sleep(1000);
    }
    process.removeListener(sig, handler);
    console.log('bye');
    process.kill(process.pid, sig);
  };
  process.on('SIGTERM', handler);
  console.log(process.pid);
  while (true) {
    console.log('.');
    await sleep(1000);
  }
})()
