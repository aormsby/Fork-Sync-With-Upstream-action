const core = require('@actions/core');
const exec = require('@actions/exec');

async function main() {
  try {
    let myOutput = '';
    let myError = '';
    
    const options = {};
    options.listeners = {
      stdout: (data) => {
        myOutput += data.toString();
      },
      stderr: (data) => {
        myError += data.toString();
        core.error  = myError;
      }
    };
    // options.cwd = './lib';

    await exec.exec('sh', [__dirname + '/entry/config_and_run.sh'], options);

  } catch (error) {
    core.setFailed(error.message);
  }
}

main();
