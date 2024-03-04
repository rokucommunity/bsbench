import { CompilerPlugin } from "brighterscript";

class Plugin implements CompilerPlugin {
    name = 'benchmark';

}
export default () => {
    return new Plugin();
}
