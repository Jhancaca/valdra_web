import styles from "./custom-lab-callout.module.css";

export function CustomLabCallout() {
  return <section className={styles.section} aria-labelledby="lab-title"><div className={`${styles.content} grid-surface`}><div className={styles.inner}><div><p className={styles.eyebrow}>{"// MAKE IT YOURS"}</p><h2 id="lab-title" className={styles.title}>CUSTOM<br /><span className={styles.accent}>LAB_</span></h2></div><div className={styles.copy}><p>Una superficie para construir tu propia señal. El flujo de personalización se activará después de validar el diseño técnico.</p><a className={styles.link} href="#">Explorar laboratorio →</a></div></div></div></section>;
}
