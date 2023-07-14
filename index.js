(async () => {
  const sig = 'SIGTERM';
  const handler = async (sig) => {
    console.log(sig, 'received; shutting down gracefully');
    for (let i = 0; i < 3; i++) {
      console.log('+');
      await new Promise(r => setTimeout(r, 1000));
    }
    process.removeListener(sig, handler);
    console.log('bye');
    process.kill(process.pid, sig);
  };
  process.on(sig, handler);
  console.log(process.pid);
  while (true) {
    console.log('.');
    await new Promise(r => setTimeout(r, 1000));
  }
})()
