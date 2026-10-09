import {createClient} from 'https://esm.sh/@supabase/supabase-js@2';
const cfg=window.GSA_CONFIG;
export const configured=!!(cfg?.supabaseUrl && cfg?.supabaseAnonKey && !cfg.supabaseUrl.includes('YOUR_PROJECT'));
export const db=configured?createClient(cfg.supabaseUrl,cfg.supabaseAnonKey):null;
export const value=id=>document.getElementById(id).value.trim();
export function show(id,msg,error=false){const el=document.getElementById(id);el.textContent=msg;el.className='message '+(error?'error':'success')}
